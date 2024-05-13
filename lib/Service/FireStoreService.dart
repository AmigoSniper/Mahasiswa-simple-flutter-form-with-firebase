import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  //get
  final CollectionReference mahasiswa =
      FirebaseFirestore.instance.collection('mahasiswa');
  //create
  Future<void> addmahasiswa(int NIM, String Nama, String JenisKelamin,
      String TanggalLahir, String Sekolah, String Jurusan) {
    return mahasiswa.add({
      'NIM': NIM,
      'Nama': Nama,
      'JenisKelamin': JenisKelamin,
      'TanggalLahir': TanggalLahir,
      'Sekolah': Sekolah,
      'Jurusan': Jurusan
    });
  }

  //read
  Stream<QuerySnapshot> getmahasiswa() {
    final mahasiswaStream =
        mahasiswa.orderBy('Nama', descending: false).snapshots();
    return mahasiswaStream;
  }

  //update
  Future<void> updatemahasiswa(
      String ID,
      int NIM,
      String Nama,
      String JenisKelamin,
      String TanggalLahir,
      String Sekolah,
      String Jurusan) {
    return mahasiswa.doc(ID).update({
      'NIM': NIM,
      'Nama': Nama,
      'JenisKelamin': JenisKelamin,
      'TanggalLahir': TanggalLahir,
      'Sekolah': Sekolah,
      'Jurusan': Jurusan
    });
  }

  //delete

  Future<void> deletemahasiswa(String ID) {
    return mahasiswa.doc(ID).delete();
  }

  //check NIM
  Future<bool> checkNIM(int NIM) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('mahasiswa')
        .where('NIM', isEqualTo: NIM)
        .get();
    return querySnapshot.docs.isEmpty;
  }
}
