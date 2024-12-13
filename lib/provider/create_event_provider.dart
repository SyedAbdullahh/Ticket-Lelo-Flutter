import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ticketlelo/exceptions/cloud_storage_exceptions.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:ticketlelo/services/cloud/firebase_cloud_storage.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

class CreateEventProvider with ChangeNotifier
{
  File? _image;
  bool _loader=false;
  bool get loader=>_loader;

  late final ImagePicker _picker=ImagePicker();
  late final ImageCropper _cropper=ImageCropper();
  late final FirebaseCloudStorage _cloudStorage=FirebaseCloudStorage();
  late final FirebaseStorage _storage=FirebaseStorage.instance;
  late final AuthService _authService=AuthService.Firebase();
  String _startDtText='Select Start Date And Time';
  String get startDtText=>_startDtText;

  String _endDtText='Select Event End Date And Time';
  String get endDtText=>_endDtText;

  DateTime? dateTime;

  File? get image=>_image;

  Future<List<Country>> getAllCountry()
  async
  {
    final countries = await getAllCountries();
    //developer.log(countries.toString());
    return countries;
  }



  Future getImageFromGallery()
  async
  {
    final pickedFile=await _picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    if(pickedFile!=null)
    {
      final croppedImage= await _cropper.cropImage(sourcePath: pickedFile.path, aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3));
      if(croppedImage!=null)
      {
        _image=File(croppedImage.path);
        notifyListeners();
      }

    }
    else
    {
      developer.log("Image not Picked by User");
    }
  }

  void submit(BuildContext context,String eventName, String eventDescription, String eventCategory,int price, String eventLocation,String eventCountry, String eventCity, DateTime startDateRaw, DateTime endDateRaw,int maxParticipants, String settlementAcc)
  async{
    try{
      _loader=true;
      notifyListeners();
      Reference ref=_storage.ref('/posters${DateTime.now().microsecondsSinceEpoch}');
      UploadTask uploadTask=ref.putFile(_image!.absolute);
      await Future.value(uploadTask);
      var newUrl=await ref.getDownloadURL();
      final event=_cloudStorage.createEvent(_authService.CurrentUser!.id, _authService.CurrentUser!.displayName!, eventName, eventDescription, eventCategory, price,newUrl.toString(), eventLocation, eventCity, eventCountry, startDateRaw, endDateRaw ,maxParticipants,settlementAcc);
      if(event!=null) {
        _loader=false;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event Generated'),
          duration: Durations.extralong4,

        ));}
        else
         {
           _loader=false;
           notifyListeners();
         }

    }
    on FirebaseException
    catch(e)
    {
      if(e.code=='unknown')
       {
         developer.log("Exception Code Waali is:"+e.code);
         throw UnknownErrorException();
       }
      if(e.code=='object-found-not')
       {
        throw ObjectNotFoundException();
       }
      else if (e.code == 'bucket-not-found') {
        throw BucketNotFoundException();
      } else if (e.code == 'project-not-found') {
        throw ProjectNotFoundException();
      } else if (e.code == 'quota-exceeded') {
        throw QuotaExceededException();
      } else if (e.code == 'unauthenticated') {
        throw UnauthenticatedException();
      } else if (e.code == 'unauthorized') {
        throw UnauthorizedException();
      } else if (e.code == 'retry-limit-exceeded') {
        throw RetryLimitExceededException();
      } else if (e.code == 'invalid-checksum') {
        throw InvalidChecksumException();
      } else if (e.code == 'canceled') {
        throw CanceledException();
      } else if (e.code == 'invalid-event-name') {
        throw InvalidEventNameException();
      } else if (e.code == 'invalid-url') {
        throw InvalidUrlException();
      } else if (e.code == 'invalid-argument') {
        throw InvalidArgumentException();
      } else if (e.code == 'no-default-bucket') {
        throw NoDefaultBucketException();
      } else if (e.code == 'cannot-slice-blob') {
        throw CannotSliceBlobException();
      } else if (e.code == 'server-file-wrong-size') {
        throw ServerFileWrongSizeException();
      } else {
        throw UnknownErrorException();
      }
    }
    catch(e)
    {
      developer.log("Exception is:"+e.toString());
    }

  }

  void setStartDate(DateTime? dt)
  {
    if(dt!=null)
     {
       dateTime=dt;
       _startDtText='Start Date: ${DateFormat('dd-MMMM-yyyy hh:mm a').format(dt)}';
       notifyListeners();
     }

  }



  void setEndDate(DateTime? dt)
  {
    if(dt!=null)
    {
      dateTime=dt;
      _endDtText='End Date: ${DateFormat('dd-MMMM-yyyy hh:mm a').format(dt)}';
      notifyListeners();
    }

  }

}



class FreePaidProvider with ChangeNotifier
{
  bool _free=true;
  bool get free=>_free;

  void setFree(bool? flag)
  {
    if(flag!=null)
      {
        _free=flag;
        notifyListeners();
      }

  }
}