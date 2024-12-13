import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:ticketlelo/services/cloud/firebase_cloud_storage.dart';
import 'dart:developer' as developer;

class ProfileProvider with ChangeNotifier
{
 bool _imageFlag=false;

 bool get imageFlag=>!(_imageFlag);
 File? _image;
 File? get image=>_image;
 AuthService _authService=AuthService.Firebase();
 bool dpFlag()=>_authService.CurrentUser!.photoUrl!=null;
 late final ImagePicker _picker=ImagePicker();
 late final ImageCropper _cropper=ImageCropper();
 late final FirebaseCloudStorage _cloudStorage=FirebaseCloudStorage();
 late final FirebaseStorage _storage=FirebaseStorage.instance;


 Future<void> getImageFromGallery()
 async
 {

  final pickedFile=await _picker.pickImage(source: ImageSource.gallery, imageQuality:20);
  if(pickedFile!=null)
  {
   final croppedImage= await _cropper.cropImage(sourcePath: pickedFile.path, aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
   if(croppedImage!=null)
   {
    final name=_authService.CurrentUser!.displayName;
    Reference ref=_storage.ref('/picture$name-${DateTime.now().microsecondsSinceEpoch}');
    _image=File(croppedImage.path);
    _imageFlag=true;
    notifyListeners();

    UploadTask uploadTask=ref.putFile(_image!.absolute);
    await Future.value(uploadTask);
    var newUrl=await ref.getDownloadURL();
    await _authService.updateProfilePicture(newUrl);
    notifyListeners();
   }

  }
  else
  {
   developer.log("Image not Picked by User");
  }
 }

}
