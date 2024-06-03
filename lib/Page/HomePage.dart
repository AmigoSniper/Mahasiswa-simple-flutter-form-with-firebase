// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formfirebase/Service/FireStoreService.dart';
import 'package:formfirebase/Service/FireStorage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'DetailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireStoreService fireStore = new FireStoreService();
  final Firestorage storage = new Firestorage();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController sekolahController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late File photo;
  late File editphoto;
  CroppedFile? _croppedFile;

  var JurusanMahasiswa;
  var Kelamin;
  var profileURL;
  var pathprofile;

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

  Future<void> CropImage(XFile _pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressQuality: 50,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
      });
    }
  }

  void clear() {
    _formKey.currentState!.fields['Jurusan']?.reset();
    _formKey.currentState!.fields['NIM']?.reset();
    nimController.clear();
    namaController.clear();
    tanggalLahirController.clear();
    sekolahController.clear();
    pathprofile = '';
    profileURL = '';
    JurusanMahasiswa = null;
    _croppedFile = null;
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
                            FormBuilderImagePicker(
                              name: 'Profil',
                              decoration: const InputDecoration(
                                  labelText: 'Photo Profil'),
                              maxImages: 1,
                              transformImageWidget: (context, displayImage) =>
                                  Card(
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.antiAlias,
                                      child: Center(
                                        child: SizedBox.square(
                                          child: displayImage,
                                        ),
                                      )),
                              availableImageSources: [
                                ImageSourceOption.gallery,
                                ImageSourceOption.camera
                              ],
                              onChanged: (value) {
                                setState(() async {
                                  XFile image = value!.first;
                                  await CropImage(image);
                                  pathprofile = _croppedFile?.path;
                                  print("Letak File ${pathprofile}");
                                  photo = File(pathprofile);
                                  print("Letak photo ${photo.path}");
                                });
                              },
                            ),
                            const SizedBox(height: 10),
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
                              onPressed: () async {
                                setState(() async {
                                  print("Letak photo 2 ${photo.path}");
                                  int NomerInduk =
                                      int.parse(nimController.text);
                                  fireStore.addmahasiswa(
                                      NomerInduk,
                                      namaController.text,
                                      Kelamin,
                                      tanggalLahirController.text,
                                      sekolahController.text,
                                      JurusanMahasiswa,
                                      await storage.Upload(photo, NomerInduk));
                                  clear();
                                  Navigator.pop(context);
                                });
                              },
                            ),
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
      String TanggalLahir, String Sekolah, String Jurusan, String ProfileLink) {
    final TextEditingController nimEdit =
        TextEditingController(text: NIM.toString());
    final TextEditingController namaEdit = TextEditingController(text: Nama);
    final TextEditingController tanggallahirEdit =
        TextEditingController(text: TanggalLahir);
    final TextEditingController sekolahEdit =
        TextEditingController(text: Sekolah);
    String? JurusanEdit = Jurusan;
    String? KelaminEdit = JenisKelamin;
    String? ProfileBaru;

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
                            FormBuilderImagePicker(
                              name: 'Profil',
                              decoration: const InputDecoration(
                                  labelText: 'Photo Profil'),
                              maxImages: 1,
                              transformImageWidget: (context, displayImage) =>
                                  Card(
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.antiAlias,
                                      child: Center(
                                        child: SizedBox.square(
                                          child: displayImage,
                                        ),
                                      )),
                              availableImageSources: [
                                ImageSourceOption.gallery,
                                ImageSourceOption.camera
                              ],
                              onChanged: (value) {
                                setState(() async {
                                  XFile imageEdit = value!.first;
                                  await CropImage(imageEdit);
                                  pathprofile = _croppedFile?.path;
                                  print(value.length);
                                  pathprofile = imageEdit.path;
                                  print("Letak File ${pathprofile}");
                                  editphoto = File(pathprofile);
                                  print("Letak photo ${editphoto.path}");
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            FormBuilderTextField(
                              controller: nimEdit,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              name: 'NIM',
                              onSubmitted: (value) {
                                int NomerInduk = int.parse(value!);
                                checkNIM(NomerInduk);
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'NIM'),
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
                              initialValue: '${JenisKelamin}',
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
                              initialValue: '${Jurusan}',
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
                              onPressed: () async {
                                int NomerInduk = int.parse(nimEdit.text);
                                await storage.deletePhoto(ProfileLink);
                                String editpath =
                                    await storage.Upload(editphoto, NomerInduk);
                                setState(() {
                                  print("Letak photo 2 ${editphoto.path}");
                                  fireStore.updatemahasiswa(
                                      ID!,
                                      NomerInduk,
                                      namaEdit.text,
                                      KelaminEdit!,
                                      tanggallahirEdit.text,
                                      sekolahEdit.text,
                                      Jurusan,
                                      editpath);
                                  clear();
                                  Navigator.pop(context);
                                });
                              },
                            ),
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
                String ProfileLink = data['Profile'];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(ProfileLink),
                    ),
                    title: Text(Nama),
                    tileColor: Colors.cyan,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              fireStore.deletemahasiswa(ID);
                              storage.deletePhoto(ProfileLink);
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              editMahasiswa(ID, NIM, Nama, JenisKelamin,
                                  TanggalLahir, Sekolah, Jurusan, ProfileLink);
                            },
                            icon: Icon(Icons.edit))
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                        return Detailpage(
                          nama: Nama,
                          nim: NIM,
                          jenisKelamin: JenisKelamin,
                          tanggalLahir: TanggalLahir,
                          sekolah: Sekolah,
                          jurusan: Jurusan,
                          ProfileURL: ProfileLink,
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
