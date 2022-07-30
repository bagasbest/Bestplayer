import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import '../../database/database_service.dart';
import '../../widget/theme.dart';
import '../logn_screen.dart';

class EditUsername extends StatefulWidget {
  final String name;
  final String role;

  EditUsername({
    required this.name,
    required this.role,
  });

  @override
  State<EditUsername> createState() => _EditUsernameState();
}

class _EditUsernameState extends State<EditUsername> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  bool isImageAdd = false;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile Saya"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFFD94555),
                ),
                child:  Center(
                        child: (_image == null)
                            ? InkWell(
                                onTap: () async {
                                  _image =
                                      await DatabaseService.getImageGallery();
                                  if (_image == null) {
                                    setState(() {
                                      toast("Gagal ambil foto");
                                    });
                                  } else {
                                    setState(() {
                                      isImageAdd = true;
                                      toast('Berhasil menambah foto');
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    File(
                                      _image!.path,
                                    ),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              ),
                      ),
              ),
              const SizedBox(
                height: 16,
              ),

              /// KOLOM NAMA
              Container(
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: 'Nama Lengkap',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama Lengkap tidak boleh kosong';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(
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
                    setState(() {
                      _visible = true;
                    });

                    String? url = (_image != null)
                            ? await DatabaseService.uploadImageReport(_image!)
                            : null;

                    String userId = FirebaseAuth.instance.currentUser!.uid;
                    DatabaseService.updateProfile(
                      _nameController.text,
                      (url != null) ? url : '',
                      userId,
                      widget.role
                    );

                    setState(() {
                      _visible = false;
                      _nameController.text = "";
                      _image = null;
                      isImageAdd = false;
                    });

                    setState(() {
                      _visible = false;
                    });
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
                      'Simpan Perubahan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
