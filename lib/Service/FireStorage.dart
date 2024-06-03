import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Firestorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> Upload(File Photo, int nim) async {
    try {
      //Generate Name
      String GenerateName = "${nim}.${DateTime.now().toString()}";
      print(GenerateName);
      //Create Refrence in Firebase Storage
      Reference storageRefrence =
          _storage.ref().child('profiles/${GenerateName}');
      //Upload File
      UploadTask uploadTask = storageRefrence.putFile(Photo);
      //Wait Upload
      TaskSnapshot taskSnapshot = await uploadTask;
      //Get download URL
      String Link = await taskSnapshot.ref.getDownloadURL();
      return Link;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> deletePhoto(String ProfileUrl) {
    final ref = FirebaseStorage.instance.refFromURL(ProfileUrl);
    print(ref);
    return ref.delete();
  }
}
