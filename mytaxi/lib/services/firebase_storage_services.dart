
import 'dart:io';

import 'package:mytaxi/services/storage_base.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService implements StorageBase{
  final FirebaseStorage _firebaseStorage =FirebaseStorage.instance;
  StorageReference _storageReference;
  @override
  Future<String> uploadFile(String userID, String fileType, File userImage) async{
    _storageReference=_firebaseStorage.ref().child(userID).child(fileType).child("profil_foto.png");
    var uploadTask= _storageReference.putFile(File(userImage.path));
    var url=await (await uploadTask.onComplete).ref.getDownloadURL();
    return url;
  }
  
}