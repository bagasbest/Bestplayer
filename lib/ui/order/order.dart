import 'package:bestplayer/ui/order/order_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String role = "";
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String dropdownValue = 'Semua';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() {
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      setState(() {
        setState(() {
          role = value.data()!["role"];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: buildMaterialColor(const Color(0xFFD94555)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Order"),
        ),
        body: (role != '')
            ? Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(
                      16,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton<String>(
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
                        });
                      },
                      items: <String>[
                        'Semua',
                        'Delivered',
                        'Revision',
                        'Accepted',
                        'Payment',
                        'Completed',
                        'Diproduksi',
                        'Dikemas',
                        'Dikirim',
                        'Produk Diterima',
                      ].map<DropdownMenuItem<String>>((String value) {
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
                  Container(
                    margin: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 80,
                    ),
                    child: StreamBuilder(
                      stream: (role == "user")
                          ? (dropdownValue == 'Semua')
                              ? FirebaseFirestore.instance
                                  .collection('order')
                                  .where("teamId", isEqualTo: uid)
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection('order')
                                  .where("teamId", isEqualTo: uid)
                                  .where("status", isEqualTo: dropdownValue)
                                  .snapshots()
                          : (dropdownValue == 'Semua')
                              ? FirebaseFirestore.instance
                                  .collection('order')
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection('order')
                                  .where('status', isEqualTo: dropdownValue)
                                  .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return (snapshot.data!.size > 0)
                              ? OrderList(
                                  document: snapshot.data!.docs.reversed.toList(),
                                  role: role,
                                )
                              : _emptyData();
                        } else {
                          return _emptyData();
                        }
                      },
                    ),
                  ),
                ],
              )
            : _emptyData(),
      ),
    );
  }

  Widget _emptyData() {
    return Container(
      child: Center(
        child: Text(
          'Tidak Ada Order\nTersedia',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
