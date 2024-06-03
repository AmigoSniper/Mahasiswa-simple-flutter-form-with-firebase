import 'package:flutter/material.dart';
import 'package:formfirebase/Service/FireStoreService.dart';

class Detailpage extends StatefulWidget {
  final String nama;
  final int nim;
  final String jenisKelamin;
  final String tanggalLahir;
  final String sekolah;
  final String jurusan;
  final String ProfileURL;

  const Detailpage(
      {Key? key,
      required this.nama,
      required this.nim,
      required this.jenisKelamin,
      required this.tanggalLahir,
      required this.sekolah,
      required this.jurusan,
      required this.ProfileURL});

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.nama}')),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: Center(
                        child: SizedBox.square(
                          dimension: 100,
                          child: Image.network('${widget.ProfileURL}'),
                        ),
                      )),
                  ListTile(
                    leading: Icon(Icons.perm_identity),
                    title: Text('NIM: ${widget.nim}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Nama: ${widget.nama}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.wc),
                    title: Text('Jenis Kelamin: ${widget.jenisKelamin}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.cake),
                    title: Text('Tanggal Lahir: ${widget.tanggalLahir}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('Sekolah: ${widget.sekolah}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.school_outlined),
                    title: Text('Jurusan: ${widget.jurusan}'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
