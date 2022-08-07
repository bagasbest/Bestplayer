import 'package:bestplayer/database/database_service.dart';
import 'package:bestplayer/ui/logn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../widget/theme.dart';

class OrderResi extends StatefulWidget {
  final String orderId;
  final String role;
  final String resi;

  OrderResi({
    required this.orderId,
    required this.role,
    required this.resi,
  });

  @override
  State<OrderResi> createState() => _OrderResiState();
}

class _OrderResiState extends State<OrderResi> {
  bool _isLoading = false;
  final resi = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.resi != '') {
      setState(() {
        resi.text = widget.resi;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            (widget.role == 'user') ? 'Cek Resi' : 'Inputkan Resi',
          ),
        ),
        body: (widget.role == 'user')
            ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        controller: resi,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Input Resi',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
            )
            : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        controller: resi,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Input Resi',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 26,
                    ),

                    /// LOADING INDIKATOR
                    Visibility(
                      visible: _isLoading,
                      child: const SpinKitRipple(
                        color: Color(0xFFD94555),
                      ),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        bool uploadResi = await DatabaseService.uploadResi(
                          resi.text,
                          widget.orderId,
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        if (uploadResi) {
                          toast('Sukses mengupload Resi');
                        } else {
                          toast('Gagal mengupload Resi');
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
                            'Simpan Resi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
      ),
    );
  }
}
