// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formfirebase/Service/FireStoreService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireStoreService fireStore = new FireStoreService();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController sekolahController = TextEditingController();
  var JurusanMahasiswa;
  var Kelamin;

  List<String> ListJurusan = [
    'D3-Teknologi Informasi',
    'D4-Teknik Informatika',
    'D4-Sistem Informasi Bisnis',
    'Akuntansi Manajemen',
    'Bahasa Inggris untuk Komunikasi Bisnis dan Profesional',
    'Keuangan',
    'Manajemen Pemasaran',
    'Manajemen Rekayasa Konstruksi',
    'Pengelolaan Arsip dan Rekaman Informasi',
    'Sistem Kelistrikan',
    'Teknik Elektronika',
    'Teknik Informatika',
    'Teknik Jaringan Telekomunikasi Digital',
    'Teknologi Kimia Industri',
    'Teknik Mesin Produksi dan Perawatan',
    'Teknik Otomotif Elektronik',
    'Teknologi Rekayasa Konstruksi Jalan dan Jembatan',
    'Usaha Perjalanan Wisata',
    'Sistem Informasi Bisnis',
    'Bahasa Inggris Untuk Industri Pariwisata',
    'D3-Administrasi Bisnis',
    'D3-Akuntansi',
    'D3-Teknik Elektronika',
    'D3-Teknik Kimia',
    'D3-Teknologi Konstruksi Jalan, Jembatan, dan Bangunan Air',
    'D3-Teknik Listrik',
    'D3-Teknik Mesin',
    'D3-Teknologi Pemeliharaan Pesawat Udara',
    'D3-Teknologi Pertambangan',
    'D3-Teknik Sipil',
    'D3-Teknik Telekomunikasi',
    'Pengembangan Piranti Lunak Situs',
    'S2 Terapan Teknik Elektro',
    'S2 Terapan Sistem Informasi Akuntansi',
    'S2 Terapan Rekayasa Teknologi Manufaktur',
    'S2 Terapan Rekayasa Teknologi Informasi',
    'D-IV Teknik Elektronika',
    'D-IV Teknik Mesin Produksi dan Perawatan',
    'D-IV Keuangan',
    'D-III Teknik Mesin',
    'D-III Akuntansi',
    'D-III Manajemen Informatika',
    'D-IV Teknologi Rekayasa Otomotif',
    'D-III Teknologi Sipil',
    'D-III Akuntansi',
    'D-III Teknologi Informasi'
  ];

  final ScrollController _firstController = ScrollController();

  final _formKey = GlobalKey<FormBuilderState>();

  void checkNIM(int NIM) async {
    bool check = await fireStore.checkNIM(NIM);

    if (!check) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "NIM telah dipakai",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "NIM bisa dipakai",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }

  void clear() {
    _formKey.currentState?.reset();
    _formKey.currentState!.fields['Jurusan']?.reset();
    nimController.clear();
    namaController.clear();
    tanggalLahirController.clear();
    sekolahController.clear();
  }

  void addMahasiswa() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Tambah Mahasiswa'),
              content: SingleChildScrollView(
                controller: _firstController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              controller: nimController,
                              keyboardType: TextInputType.number,
                              name: 'NIM',
                              onSubmitted: (value) {
                                int NomerInduk = int.parse(value!);
                                checkNIM(NomerInduk);
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'NIM'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.integer(),
                                FormBuilderValidators.equalLength(10),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              controller: namaController,
                              name: 'Nama',
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nama'),
                            ),
                            const SizedBox(height: 10),
                            FormBuilderRadioGroup(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Jenis Kelamin',
                              ),
                              initialValue: null,
                              onChanged: (value) {
                                setState(() {
                                  Kelamin = value;
                                });
                              },
                              name: 'gender',
                              options: ['Male', 'Female']
                                  .map((e) => FormBuilderFieldOption(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(growable: false),
                              controlAffinity: ControlAffinity.trailing,
                            ),
                            const SizedBox(height: 10),
                            FormBuilderDateTimePicker(
                              controller: tanggalLahirController,
                              name: 'tanggal',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Masukan Tanggal',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    tanggalLahirController.clear();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FormBuilderTextField(
                              controller: sekolahController,
                              name: 'Sekolah',
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Sekolah'),
                            ),
                            const SizedBox(height: 10),
                            FormBuilderDropdown<String>(
                              name: 'Jurusan',
                              initialValue: '',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Jurusan',
                                suffix: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['Jurusan']
                                        ?.reset();
                                  },
                                ),
                                hintText: 'Pilih Jurusan',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  JurusanMahasiswa = value;
                                });
                              },
                              items:
                                  ListJurusan.map((jurusan) => DropdownMenuItem(
                                        alignment: AlignmentDirectional.center,
                                        value: jurusan,
                                        child: Text(jurusan),
                                      )).toList(),
                            ),
                            const SizedBox(height: 10),
                            MaterialButton(
                                child: Text("Save"),
                                color: Colors.green,
                                onPressed: () {
                                  int NomerInduk =
                                      int.parse(nimController.text);
                                  fireStore.addmahasiswa(
                                      NomerInduk,
                                      namaController.text,
                                      Kelamin,
                                      tanggalLahirController.text,
                                      sekolahController.text,
                                      JurusanMahasiswa);
                                  clear();
                                  Navigator.pop(context);
                                }),
                            const SizedBox(height: 10),
                            MaterialButton(
                                child: Text("Reset"),
                                color: Colors.red,
                                onPressed: () {
                                  clear();
                                })
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  void editMahasiswa(String? ID, int NIM, String Nama, String JenisKelamin,
      String TanggalLahir, String Sekolah, String Jurusan) {
    final TextEditingController nimEdit =
        TextEditingController(text: NIM.toString());
    final TextEditingController namaEdit = TextEditingController(text: Nama);
    final TextEditingController tanggallahirEdit =
        TextEditingController(text: TanggalLahir);
    final TextEditingController sekolahEdit =
        TextEditingController(text: Sekolah);
    String? JurusanEdit = Jurusan;
    String? KelaminEdit = JenisKelamin;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Edit data $Nama'),
              content: SingleChildScrollView(
                controller: _firstController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              controller: nimEdit,
                              keyboardType: TextInputType.number,
                              name: 'NIM',
                              onSubmitted: (value) {
                                int NomerInduk = int.parse(value!);
                                checkNIM(NomerInduk);
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'NIM'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.integer(),
                                FormBuilderValidators.equalLength(10),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              controller: namaEdit,
                              name: 'Nama',
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nama'),
                            ),
                            const SizedBox(height: 10),
                            FormBuilderRadioGroup(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Jenis Kelamin',
                              ),
                              initialValue: null,
                              onChanged: (value) {
                                setState(() {
                                  KelaminEdit = value;
                                });
                              },
                              name: 'gender',
                              options: ['Male', 'Female']
                                  .map((e) => FormBuilderFieldOption(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(growable: false),
                              controlAffinity: ControlAffinity.trailing,
                            ),
                            const SizedBox(height: 10),
                            FormBuilderDateTimePicker(
                              controller: tanggallahirEdit,
                              name: 'tanggal',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Masukan Tanggal',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    tanggallahirEdit.clear();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FormBuilderTextField(
                              controller: sekolahEdit,
                              name: 'Sekolah',
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Sekolah'),
                            ),
                            const SizedBox(height: 10),
                            FormBuilderDropdown<String>(
                              name: 'Jurusan',
                              initialValue: '',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Jurusan',
                                suffix: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['Jurusan']
                                        ?.reset();
                                  },
                                ),
                                hintText: 'Pilih Jurusan',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  JurusanEdit = value;
                                });
                              },
                              items:
                                  ListJurusan.map((jurusan) => DropdownMenuItem(
                                        alignment: AlignmentDirectional.center,
                                        value: jurusan,
                                        child: Text(jurusan),
                                      )).toList(),
                            ),
                            const SizedBox(height: 10),
                            MaterialButton(
                                child: Text("Save"),
                                color: Colors.green,
                                onPressed: () {
                                  int NomerInduk = int.parse(nimEdit.text);
                                  fireStore.updatemahasiswa(
                                      ID!,
                                      NomerInduk,
                                      namaEdit.text,
                                      KelaminEdit!,
                                      tanggallahirEdit.text,
                                      sekolahEdit.text,
                                      Jurusan);
                                  clear();
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mahasiswa Form"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addMahasiswa();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.getmahasiswa(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List mahasiswaList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: mahasiswaList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = mahasiswaList[index];
                String ID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                int NIM = data['NIM'];
                String Nama = data['Nama'];
                String JenisKelamin = data['JenisKelamin'];
                String TanggalLahir = data['TanggalLahir'];
                String Sekolah = data['Sekolah'];
                String Jurusan = data['Jurusan'];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.man),
                    title: Text(Nama),
                    tileColor: Colors.cyan,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              fireStore.deletemahasiswa(ID);
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              editMahasiswa(ID, NIM, Nama, JenisKelamin,
                                  TanggalLahir, Sekolah, Jurusan);
                            },
                            icon: Icon(Icons.edit))
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(title: Text('$Nama')),
                          body: ListView(
                            padding: EdgeInsets.all(20.0),
                            children: <Widget>[
                              Card(
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.perm_identity),
                                        title: Text('NIM: $NIM'),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.person),
                                        title: Text('Nama: $Nama'),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.wc),
                                        title: Text(
                                            'Jenis Kelamin: $JenisKelamin'),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.cake),
                                        title: Text(
                                            'Tanggal Lahir: $TanggalLahir'),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.school),
                                        title: Text('Sekolah: $Sekolah'),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.school_outlined),
                                        title: Text('Jurusan: $Jurusan'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }));
                    },
                  ),
                );
              },
            );
          } else {
            return const Text('Data Kosong');
          }
        },
      ),
    );
  }
}
