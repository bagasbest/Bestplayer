import 'package:bestplayer/ui/order/order_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class OrderList extends StatelessWidget {
  final List<DocumentSnapshot> document;
  final String role;
  final NumberFormat format = NumberFormat('#,##0', 'en_US');

  OrderList({
    required this.document,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String orderId = document[i]['orderId'].toString();
        double discount50 = document[i]['discount50'];
        String paket = document[i]['paket'].toString();
        int totalHarga = document[i]['totalHarga'];
        String gambar = document[i]['gambar'].toString();
        String jerseyDepan = document[i]['jerseyDepan'].toString();
        String jerseyBelakang = document[i]['jerseyBelakang'].toString();
        String celana = document[i]['celana'].toString();
        int waktuDesainInMillis = document[i]['waktuDesainInMillis'];
        int revisiTotal = document[i]['revisiTotal'];
        String teamId = document[i]['teamId'].toString();
        String teamName = document[i]['teamName'].toString();
        String teamPhone = document[i]['teamPhone'].toString();
        String teamAddress = document[i]['teamAddress'].toString();
        String orderDate = document[i]['orderDate'].toString();
        String status = document[i]['status'].toString();
        String qty = document[i]['qty'].toString();
        String sponsor = document[i]['sponsor'].toString();

        return GestureDetector(
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (context) => OrderDetail(
                orderId: orderId,
                paket: paket,
                gambar: gambar,
                totalHarga: totalHarga,
                discount50: discount50,
                jerseyDepan: jerseyDepan,
                jerseyBelakang: jerseyBelakang,
                celana: celana,
                waktuDesainInMillis: waktuDesainInMillis,
                revisiTotal: revisiTotal,
                teamId: teamId,
                teamName: teamName,
                teamPhone: teamPhone,
                teamAddress: teamAddress,
                orderDate: orderDate,
                status: status,
                qty: qty,
                sponsor: sponsor,
              ),
            );
            Navigator.push(context, route);
          },
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paket,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Oleh: $teamName',
                  ),
                  Text(
                    'Banyaknya: $qty setel',
                  ),
                  Expanded(
                    child: Text(
                      'Harga: Rp.${format.format(totalHarga)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Tanggal Order: $orderDate',
                          maxLines: 1,

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFD94555),
                          borderRadius: BorderRadius.circular(7)
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
