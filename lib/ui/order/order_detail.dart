import 'package:bestplayer/database/database_service.dart';
import 'package:bestplayer/ui/order/order_design.dart';
import 'package:bestplayer/ui/order/order_full.dart';
import 'package:bestplayer/ui/order/order_payment.dart';
import 'package:bestplayer/ui/order/order_revision.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../widget/theme.dart';
import '../logn_screen.dart';
import 'order_resi.dart';

class OrderDetail extends StatefulWidget {
  final String orderId;
  final String paket;
  final String gambar;
  final int totalHarga;
  final double discount50;
  final String jerseyDepan;
  final String jerseyBelakang;
  final String celana;
  final int waktuDesainInMillis;
  final int revisiTotal;
  final String teamId;
  final String teamName;
  final String teamPhone;
  final String teamAddress;
  final String orderDate;
  String status;
  final String qty;
  final String sponsor;
  final String role;
  final String keteranganRevisi;
  String paymentProof;
  final String paymentStatus;
  final String resi;
  final String paymentMethod;

  OrderDetail({
    required this.orderId,
    required this.paket,
    required this.gambar,
    required this.totalHarga,
    required this.discount50,
    required this.jerseyDepan,
    required this.jerseyBelakang,
    required this.celana,
    required this.waktuDesainInMillis,
    required this.revisiTotal,
    required this.teamId,
    required this.teamName,
    required this.teamPhone,
    required this.teamAddress,
    required this.orderDate,
    required this.status,
    required this.qty,
    required this.sponsor,
    required this.role,
    required this.keteranganRevisi,
    required this.paymentProof,
    required this.paymentStatus,
    required this.resi,
    required this.paymentMethod,
  });

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final NumberFormat format = NumberFormat('#,##0', 'en_US');
  String deadline = '';
  final _keteranganDesainController = TextEditingController();
  XFile? _desainUpload;
  bool isDesainUpload = false;
  String desainUrl = '';
  bool _designUploadLoading = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.waktuDesainInMillis != 0) {
      var dt = DateTime.fromMillisecondsSinceEpoch(widget.waktuDesainInMillis);

      setState(() {
        deadline = DateFormat('dd-MM-yyyy').format(dt);
      });
    } else {
      setState(() {
        deadline = 'Berhenti (Desain Sudah Terunggah)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('order ${widget.paket}'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: InkWell(
                onTap: () {
                  showMenuOption(context);
                },
                child: Icon(Icons.menu),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.gambar,
                fit: BoxFit.fill,
                height: 330,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 16,
              ),

              (widget.status == 'Dikemas' &&
                      widget.role == 'user' &&
                      widget.paymentMethod == 'DP' &&
                      widget.paymentProof == '')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'Silahkan Upload bukti pelunasan order untuk melanjutkan proses pengiriman',
                          ),
                        ),
                      ),
                    )
                  : Container(),

              (widget.status == 'Dikemas' &&
                      widget.role == 'user' &&
                      widget.paymentMethod == 'DP' &&
                      widget.paymentProof != '')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'Silahkan tunggu admin mengonfirmasi bukti pelunasan anda',
                          ),
                        ),
                      ),
                    )
                  : Container(),

              (widget.status == 'Dikemas' &&
                      widget.role == 'admin' &&
                      widget.paymentMethod == 'DP' &&
                      widget.paymentProof == '')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'Silahkan tunggu user mengupload bukti pelunasan order',
                          ),
                        ),
                      ),
                    )
                  : Container(),

              (widget.status == 'Dikemas' &&
                      widget.role == 'admin' &&
                      widget.paymentMethod == 'DP' &&
                      widget.paymentProof != '')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'User telah mengupload bukti pelunasan, silahkan konfirmasi bukti pembayaran tersebut!',
                          ),
                        ),
                      ),
                    )
                  : Container(),

              (widget.status == 'Accepted' &&
                      widget.role == 'user' &&
                      widget.paymentProof == '')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'Silahkan upload bukti pembayaran melalui metode DP atau pembayaran Full',
                          ),
                        ),
                      ),
                    )
                  : Container(),


              (widget.status == 'Payment' &&
                  widget.role == 'user' &&
                  widget.paymentProof == '')
                  ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(
                      16,
                    ),
                    child: Text(
                      'Silahkan upload bukti pembayaran dengan jelas, sehingga admin dapat mengonfirmasi bukti pembayaran anda',
                    ),
                  ),
                ),
              )
                  : Container(),

              (widget.status == 'Payment' &&
                      widget.role == 'user' &&
                      widget.paymentProof != '')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'Silahkan tunggu admin mengonfirmasi bukti pembayaran anda',
                          ),
                        ),
                      ),
                    )
                  : Container(),

              (widget.status == 'Accepted' &&
                      widget.role == 'admin' &&
                      widget.paymentProof == '')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'Silahkan tunggu user mengunggah bukti pembayaran',
                          ),
                        ),
                      ),
                    )
                  : Container(),

              (widget.status == 'Payment' &&
                      widget.role == 'admin' &&
                      widget.paymentProof == '')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'Silahkan tunggu user mengupload bukti pembayaran',
                          ),
                        ),
                      ),
                    )
                  : Container(),


              (widget.status == 'Payment' &&
                  widget.role == 'admin' &&
                  widget.paymentProof != '')
                  ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(
                      16,
                    ),
                    child: Text(
                      'User sudah mengupload bukti pembayaran, silahkan konfirmasi bukti pembayaran user',
                    ),
                  ),
                ),
              )
                  : Container(),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keterangan Order',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Nama Tim: ${widget.teamName}',
                        ),
                        Text(
                          'Nomor Telepon Tim: ${widget.teamPhone}',
                        ),
                        Text(
                          'Alamat Tim: ${widget.teamAddress}',
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Kuantitas Order: ${widget.qty} Setel',
                        ),
                        Text(
                          'Sponsor: ${widget.sponsor}',
                        ),
                        Text(
                          'Total Harga: Rp.${format.format(widget.totalHarga)}',
                        ),
                        Text(
                          'Tanggal Order: ${widget.orderDate}',
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Status Order: ${widget.status}',
                        ),
                        Text(
                          'Revisi Tersisa: ${widget.revisiTotal}',
                        ),
                        Text(
                          'Deadline: $deadline',
                          style: TextStyle(
                              color: Color(0xFFD94555),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ((widget.status == 'Delivered' || widget.status == 'Revision') &&
                      widget.role == 'admin')
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                          10,
                        )),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload Desain',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    _designUploadLoading = true;
                                  });

                                  _desainUpload =
                                      await DatabaseService.getImageGallery();
                                  desainUrl =
                                      await DatabaseService.uploadImageReport(
                                          _desainUpload!);

                                  setState(() {
                                    _designUploadLoading = false;
                                  });

                                  if (desainUrl == '') {
                                    setState(() {
                                      toast("Gagal ambil foto");
                                    });
                                  } else {
                                    setState(() {
                                      isDesainUpload = true;
                                      toast('Berhasil menambah foto');
                                    });
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (desainUrl != '')
                                        ? Colors.red[200]
                                        : Color(0xFFD94555),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (desainUrl != '')
                                          ? 'Foto Desain Terpilih'
                                          : 'Pilih Foto Desain',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  controller: _keteranganDesainController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                    hintText: 'Keterangan Desain',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 26,
                              ),

                              /// LOADING INDIKATOR
                              Visibility(
                                visible: _designUploadLoading,
                                child: const SpinKitRipple(
                                  color: Color(0xFFD94555),
                                ),
                              ),
                              const SizedBox(
                                height: 26,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (desainUrl != '' &&
                                      _keteranganDesainController.text != '') {
                                    setState(() {
                                      _designUploadLoading = true;
                                    });
                                    String uid = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                    bool isDesignUpload =
                                        await DatabaseService.uploadDesign(
                                      uid,
                                      widget.orderId,
                                      desainUrl,
                                      _keteranganDesainController.text,
                                    );

                                    setState(() {
                                      _designUploadLoading = false;
                                      _keteranganDesainController.clear();
                                      desainUrl = '';
                                      _desainUpload = null;
                                    });

                                    if (isDesignUpload) {
                                      setState(() {
                                        deadline =
                                            'Berhenti (Desain Sudah Terunggah)';
                                      });
                                      await DatabaseService.updateOrderDeadline(
                                          widget.orderId);
                                      toast('Berhasil mengunggah desain');
                                    } else {
                                      toast('Gagal mengunggah desain');
                                    }
                                  } else {
                                    toast(
                                        'Silahkan upload desain dan tulis keterangan terlebih dahulu');
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFD94555),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'upload Desain',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),

              /// LOADING INDIKATOR
              Visibility(
                visible: _isLoading,
                child: const SpinKitRipple(
                  color: Color(0xFFD94555),
                ),
              ),
              const SizedBox(
                height: 16,
              ),

              ((widget.status == 'Completed') && widget.role == 'admin')
                  ? InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        bool updateOrderStatus =
                            await DatabaseService.updateOrderStatus(
                                widget.orderId, 'Diproduksi');

                        bool updateChatStatus =
                            await DatabaseService.updateChat(
                          widget.teamId,
                          'Diproduksi',
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        if (updateOrderStatus && updateChatStatus) {
                          toast(
                              'Berhasil mengubah status order menjadi Diproduksi');
                          setState(() {
                            widget.status = 'Diproduksi';
                          });
                        } else {
                          toast('Gagal mengupdate status');
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFD94555),
                        ),
                        child: Center(
                          child: Text(
                            'Ubah Status Menjadi Diproduksi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              ((widget.status == 'Diproduksi') && widget.role == 'admin')
                  ? InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        bool updateOrderStatus = false;
                        if(widget.paymentMethod == 'DP') {
                          updateOrderStatus =
                          await DatabaseService.updateOrderStatus(
                            widget.orderId,
                            'Dikemas',
                          );
                        } else {
                          updateOrderStatus =
                          await DatabaseService.updateDikemas(
                            widget.orderId,
                            'Dikemas',
                          );
                        }


                        bool updateChatStatus =
                            await DatabaseService.updateChat(
                          widget.teamId,
                          'Dikemas',
                        );

                        setState(() {
                          if (widget.paymentMethod != 'FULL') {
                            widget.paymentProof = '';
                          }
                          _isLoading = false;
                        });

                        if (updateOrderStatus && updateChatStatus) {
                          toast(
                              'Berhasil mengubah status order menjadi Dikemas');
                          setState(() {
                            widget.status = 'Dikemas';
                          });
                        } else {
                          toast('Gagal mengupdate status');
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFD94555),
                        ),
                        child: Center(
                          child: Text(
                            'Ubah Status Menjadi Dikemas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),

              (widget.status == 'Dikemas' &&
                      widget.role == 'admin' &&
                      widget.paymentMethod == 'FULL')
                  ? InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        bool updateOrderStatus =
                            await DatabaseService.updateOrderStatus(
                          widget.orderId,
                          'Dikirim',
                        );

                        bool updateChatStatus =
                            await DatabaseService.updateChat(
                          widget.teamId,
                          'Dikirim',
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        if (updateOrderStatus && updateChatStatus) {
                          toast(
                              'Berhasil mengubah status order menjadi Dikirim');
                          setState(() {
                            widget.status = 'Dikirim';
                          });
                        } else {
                          toast('Gagal mengupdate status');
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFD94555),
                        ),
                        child: Center(
                          child: Text(
                            'Ubah Status Menjadi Dikirim',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),

              (widget.status == 'Dikirim' && widget.role == 'user')
                  ? InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        bool updateOrderStatus =
                            await DatabaseService.updateOrderStatus(
                          widget.orderId,
                          'Diterima',
                        );

                        bool updateChatStatus =
                            await DatabaseService.updateChat(
                          widget.teamId,
                          'Diterima',
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        if (updateOrderStatus && updateChatStatus) {
                          toast(
                              'Berhasil mengubah status order menjadi Diterima');
                          setState(() {
                            widget.status = 'Diterima';
                          });
                        } else {
                          toast('Gagal mengupdate status');
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFD94555),
                        ),
                        child: Center(
                          child: Text(
                            'Produk Telah Diterima',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void showMenuOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Menu Opsi'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Route route = MaterialPageRoute(
                  builder: (context) => OrderDesign(
                    orderId: widget.orderId,
                    role: widget.role,
                    revisiLeft: widget.revisiTotal,
                    status: widget.status,
                  ),
                );
                Navigator.push(context, route);
              },
              child: const Text(
                'Lihat Desain Jersey',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            (widget.status == 'Revision')
                ? SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Route route = MaterialPageRoute(
                        builder: (context) => OrderRevision(
                          keteranganRevisi: widget.keteranganRevisi,
                        ),
                      );
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      'Lihat Permintaan Revisi',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                : Container(),
            (widget.status != 'Delivered' && widget.status != 'Revision')
                ? SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if(widget.status == 'Dikemas' && widget.paymentMethod == 'FULL') {
                        Route route = MaterialPageRoute(
                          builder: (context) => OrderFull(
                            paymentProof: widget.paymentProof
                          ),
                        );
                        Navigator.push(context, route);
                      } else {
                        Route route = MaterialPageRoute(
                          builder: (context) => OrderPayment(
                            discount: widget.discount50,
                            total: widget.totalHarga,
                            orderId: widget.orderId,
                            paymentProof: widget.paymentProof,
                            status: widget.status,
                            role: widget.role,
                            paymentStatus: widget.paymentStatus,
                            teamId: widget.teamId,
                            paymentMethod: widget.paymentMethod,
                          ),
                        );
                        Navigator.push(context, route);
                      }

                    },
                    child: const Text(
                      'Lihat Bukti Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                : Container(),
            (widget.status == 'Dikirim')
                ? SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Route route = MaterialPageRoute(
                        builder: (context) => OrderResi(
                          orderId: widget.orderId,
                          role: widget.role,
                          resi: widget.resi,
                        ),
                      );
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      'Cek Resi Pengiriman',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
