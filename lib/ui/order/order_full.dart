import 'package:flutter/material.dart';

import '../../widget/theme.dart';

class OrderFull extends StatefulWidget {
  final String paymentProof;

  OrderFull({
    required this.paymentProof,
  });

  @override
  State<OrderFull> createState() => _OrderFullState();
}

class _OrderFullState extends State<OrderFull> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pembayaran'),
        ),
        body: Column(
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
    );
  }
}
