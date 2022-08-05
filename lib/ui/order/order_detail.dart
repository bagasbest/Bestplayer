import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widget/theme.dart';

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
  final String status;
  final String qty;
  final String sponsor;

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
  });

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final NumberFormat format = NumberFormat('#,##0', 'en_US');
  String deadline = '';

  @override
  void initState() {
    super.initState();
    var dt = DateTime.fromMillisecondsSinceEpoch(widget.waktuDesainInMillis);

    setState((){
      deadline = DateFormat('dd-mm-yyyy').format(dt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('order ${widget.paket}'),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                         'Nama Tim: ${widget.teamName}',
                        ),
                        Text(
                          'Nomor Telepon Tim: ${widget.teamPhone}',
                        ),
                        Text(
                          'Alamat Tim: ${widget.teamAddress}',
                        ),
                        SizedBox(height: 16,),
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
                        SizedBox(height: 16,),
                        Text(
                          'Status Order: ${widget.status}',
                        ),
                        Text(
                          'Revisi Tersisa: ${widget.revisiTotal}',
                        ),
                        Text(
                          'Deadline: $deadline',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
