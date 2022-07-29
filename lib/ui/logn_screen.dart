import 'package:bestplayer/ui/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'homepage_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: buildMaterialColor(const Color(0xFFD94555)),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFD94555),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Icon(
                Icons.login,
                size: 100,
                color: Color(0xFFD94555),
              ),
              const Text(
                'LOGIN',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Masukkan Email & Kata Sandi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// KOLOM EMAIL
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 16, right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    /// KOLOM PASSWORD
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 16, right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Kata Sandi',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            child: Icon(_showPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Kata Sandi tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                      ),
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

                    /// TOMBOL LOGIN
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                          color: Color(0xFFD94555),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(29)),
                          onPressed: () async {
                            /// CEK APAKAH EMAIL DAN PASSWORD SUDAH TERISI DENGAN FORMAT YANG BENAR
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _visible = true;
                              });

                              /// Cek apakah ada no hp yang diinputkan pengguna ketika klik login
                              // var collection = FirebaseFirestore.instance.collection('users');
                              // var docSnapshot = await collection.where("phone", isEqualTo: _phoneController.text).limit(1).get();
                              // if (docSnapshot.size > 0) {
                              //   Map<String, dynamic>? data = docSnapshot.docs.first.data();
                              //   var email = data['email'];

                              /// CEK APAKAH EMAIL DAN PASSWORD SUDAH TERDAFTAR / BELUM
                              bool shouldNavigate = await _signInHandler(
                                _emailController.text,
                                _passwordController.text,
                              );

                              if (shouldNavigate) {
                                setState(() {
                                  _visible = false;
                                });

                                _formKey.currentState!.reset();

                                /// MASUK KE HOMEPAGE JIKA SUKSES LOGIN
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                        const HomepageScreen());
                                Navigator.pushReplacement(context, route);
                              } else {
                                setState(() {
                                  _visible = false;
                                });
                              }
                            } else {
                              toast(
                                  'Maaf, Email atau Kata sandi anda tidak terdaftar');
                              setState(() {
                                _visible = false;
                              });
                            }
                            //}
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => const RegisterScreen());
                        Navigator.push(context, route);
                      },
                      splashColor: Colors.grey[200],
                      child: const Text(
                        'Saya Ingin Mendaftar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD94555),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _signInHandler(String email, String password) async {
    try {
      (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;

      return true;
    } catch (error) {
      toast(
          'Terdapat kendala ketika ingin login. Silahkan periksa kembali email & password, serta koneksi internet anda');
      return false;
    }
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

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFFD94555),
      textColor: Colors.white,
      fontSize: 16.0);
}
