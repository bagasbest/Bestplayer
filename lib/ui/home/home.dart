import 'package:bestplayer/ui/home/home_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String name = "";
  final NumberFormat format = NumberFormat('#,##0', 'en_US');
  String role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      setState(() {
        name = value.data()!["name"];
        role = value.data()!["role"];
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 70,
              left: 16,
              right: 16,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Selamat Datang $name Di Aplikasi Bestplayer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFFD94555),
                    ),

                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Berikut ini adalah pilihan paket yang kami sediakan untuk kamu :)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                InkWell(
                  onTap: () {

                    String paket = 'Paket 1';
                    String image = 'assets/paket1.png';
                    int harga = 120000;
                    String jerseyDepan = 'Non-Printing';
                    String jerseyBelakang = 'Non-Printing';
                    String celana = 'Non-Printing';
                    String waktuDesain = '1 Hari';
                    int revisiTotal = 2;


                    Route route = MaterialPageRoute(
                      builder: (context) => HomeDetail(
                        paket: paket,
                        gambar: image,
                        harga: harga,
                        jerseyDepan: jerseyDepan,
                        jerseyBelakang: jerseyBelakang,
                        celana: celana,
                        waktuDesain: waktuDesain,
                        revisiTotal: revisiTotal,
                        role: role,
                      ),
                    );
                    Navigator.push(context, route);
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset('assets/paket1.png',
                              fit: BoxFit.cover, width: MediaQuery
                                  .of(context)
                                  .size
                                  .width, height: 250,),
                          ),
                          SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Paket 1',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Rp.${format.format(120000)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                'Lihat Selengkapnya >>',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                InkWell(
                  onTap: () {

                    String paket = 'Paket 2';
                    String image = 'assets/paket2.png';
                    int harga = 135000;
                    String jerseyDepan = 'Printing';
                    String jerseyBelakang = 'Non-Printing';
                    String celana = 'Non-Printing';
                    String waktuDesain = '2 Hari';
                    int revisiTotal = 3;


                    Route route = MaterialPageRoute(
                      builder: (context) => HomeDetail(
                        paket: paket,
                        gambar: image,
                        harga: harga,
                        jerseyDepan: jerseyDepan,
                        jerseyBelakang: jerseyBelakang,
                        celana: celana,
                        waktuDesain: waktuDesain,
                        revisiTotal: revisiTotal,
                        role: role,
                      ),
                    );
                    Navigator.push(context, route);
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset('assets/paket2.png',
                              fit: BoxFit.cover, width: MediaQuery
                                  .of(context)
                                  .size
                                  .width, height: 250,),
                          ),
                          SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Paket 2',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Rp.${format.format(135000)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                'Lihat Selengkapnya >>',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                InkWell(
                  onTap: () {

                    String paket = 'Paket 3';
                    String image = 'assets/paket3.png';
                    int harga = 150000;
                    String jerseyDepan = 'Printing';
                    String jerseyBelakang = 'Printing';
                    String celana = 'Non-Printing';
                    String waktuDesain = '2 Hari';
                    int revisiTotal = 3;


                    Route route = MaterialPageRoute(
                      builder: (context) => HomeDetail(
                        paket: paket,
                        gambar: image,
                        harga: harga,
                        jerseyDepan: jerseyDepan,
                        jerseyBelakang: jerseyBelakang,
                        celana: celana,
                        waktuDesain: waktuDesain,
                        revisiTotal: revisiTotal,
                        role: role,
                      ),
                    );
                    Navigator.push(context, route);
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset('assets/paket3.png',
                              fit: BoxFit.cover, width: MediaQuery
                                  .of(context)
                                  .size
                                  .width, height: 250,),
                          ),
                          SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Paket 3',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Rp.${format.format(150000)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                'Lihat Selengkapnya >>',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                InkWell(
                  onTap: () {

                    String paket = 'Paket 4';
                    String image = 'assets/paket4.png';
                    int harga = 175000;
                    String jerseyDepan = 'Printing';
                    String jerseyBelakang = 'Printing';
                    String celana = 'Printing';
                    String waktuDesain = '1 Hari';
                    int revisiTotal = 5;


                    Route route = MaterialPageRoute(
                      builder: (context) => HomeDetail(
                        paket: paket,
                        gambar: image,
                        harga: harga,
                        jerseyDepan: jerseyDepan,
                        jerseyBelakang: jerseyBelakang,
                        celana: celana,
                        waktuDesain: waktuDesain,
                        revisiTotal: revisiTotal,
                        role: role,

                      ),
                    );
                    Navigator.push(context, route);
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset('assets/paket4.png',
                              fit: BoxFit.cover, width: MediaQuery
                                  .of(context)
                                  .size
                                  .width, height: 250,),
                          ),
                          SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Paket 4',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Rp.${format.format(175000)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                'Lihat Selengkapnya >>',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red,
        g = color.green,
        b = color.blue;

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
