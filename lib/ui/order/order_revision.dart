import 'package:flutter/material.dart';

import '../../widget/theme.dart';

class OrderRevision extends StatefulWidget {
  final String keteranganRevisi;

  OrderRevision({required this.keteranganRevisi});

  @override
  State<OrderRevision> createState() => _OrderRevisionState();
}

class _OrderRevisionState extends State<OrderRevision> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Permintaan Revisi'),
        ),
        body: Center(
          child: Text(
            (widget.keteranganRevisi != '') ? 'Keterangan Revisi:\n\n${widget.keteranganRevisi}' : 'Tidak Ada Permintaan Revisi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
