import 'package:bestplayer/ui/logn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../widget/theme.dart';

class HomeDetail extends StatefulWidget {
  final String paket;
  final String gambar;
  final int harga;
  final String jerseyDepan;
  final String jerseyBelakang;
  final String celana;
  final String waktuDesain;
  final int revisiTotal;

  HomeDetail({
    required this.paket,
    required this.gambar,
    required this.harga,
    required this.jerseyDepan,
    required this.jerseyBelakang,
    required this.celana,
    required this.waktuDesain,
    required this.revisiTotal,
  });

  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  int discount = 0;
  final _qtyController = TextEditingController();

  final NumberFormat format = NumberFormat('#,##0', 'en_US');
  String dropdownValue = 'Tidak Menambahkan Sponsor';
  final _formKey = GlobalKey<FormState>();
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.paket),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          widget.paket,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keterangan:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            'Harga: Rp${format.format(widget.harga)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Jersey Depan: ${widget.jerseyDepan}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Jersey Belakang: ${widget.jerseyBelakang}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Celana: ${widget.celana}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Waktu Desain: ${widget.waktuDesain}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Jumlah Revisi: ${widget.revisiTotal} Kali',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 26,
                        ),
                        Text(
                          'Ingin order paket ini ?, silahkan lengapi formulir dibawah',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),

                        /// KOLOM NAMA
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _qtyController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Jumlah stel produk',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Jumlah stel produk tidak boleh kosong';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 26,
                        ),

                        Text(
                          'Dapatkan Diskon dengan menyertakan Bestplayer sebagai sponsor tim anda (opsional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          child:  DropdownButton<String>(
                            isExpanded: true,
                              value: dropdownValue,
                              elevation: 16,
                              style: const TextStyle(color: Color(0xFFD94555)),
                              underline: Container(
                                height: 2,
                                color: Color(0xFFD94555),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  if(dropdownValue == 'Tidak Menambahkan Sponsor') {
                                    discount = 0;
                                  } else if (dropdownValue == 'Jersey (baju) bagian depan (- Rp.15.000)') {
                                    discount = 15000;
                                  } else {
                                    discount = 10000;
                                  }
                                });
                              },
                              items: <String>['Tidak Menambahkan Sponsor', 'Jersey (baju) bagian depan (- Rp.15.000)', 'Jersey (baju) bagian belakang (- Rp.10.000)']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                        ),

                        SizedBox(
                          height: 16,
                        ),


                        /// LOADING INDIKATOR
                        Visibility(
                          visible: _visible,
                          child: const SpinKitRipple(
                            color: Color(0xFFD94555),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        InkWell(
                          onTap: () async {
                            /// CEK APAKAH KOLOM KOLOM SUDAH TERISI SEMUA
                            if (_formKey.currentState!.validate()) {
                              showConfirmDialog();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            margin: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFD94555),
                            ),
                            child: Center(
                              child: Text(
                                'Order ${widget.paket} Sekarang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showConfirmDialog() {
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
                    'Konfirmasi ${widget.paket}',
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
                  'Apakah anda yakin ingin membuat orderan ${widget.paket}?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Biaya = Rp.${format.format(widget.harga * int.parse(_qtyController.text))}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Total Diskon = Rp.${format.format(discount * int.parse(_qtyController.text))}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Total Biaya = Rp.${format.format((widget.harga * int.parse(_qtyController.text)) - (int.parse(_qtyController.text) * discount))}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
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
                  setState(() {
                    _visible = true;
                  });

                  toast('Berhasil membuat orderan');
                  Navigator.of(context).pop();

                  setState(() {
                    _visible = false;
                  });
                },
              ),
            ],
            elevation: 10,
          );
        },
      );
    }
}
