
import 'package:ticketlelo/constants/cloudStorageConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CloudEvent {
  final String eventId;
  final String eventName;
  final String eventCategory;
  final String eventDescription;
  final int eventPrice;
  final String eventPosterURL;
  final String eventLocation;
  final String eventCity;
  final String eventCountry;
  final String organizerId;
  final String organizerUserName;
  final DateTime start_dt;
  final DateTime end_dt;
  final int max_participants;
  final int curr_participants;
  final int approved;
  final String settlementAcc;

  CloudEvent(
      {required this.eventId, required this.eventName, required this.eventCategory, required this.eventDescription, required this.eventPrice, required this.eventPosterURL, required this.eventLocation, required this.eventCity, required this.eventCountry, required this.organizerId, required this.organizerUserName, required this.start_dt, required this.end_dt, required this.max_participants, required this.curr_participants, required this.approved, required this.settlementAcc});

  @override toString()
  {
    return eventName;
  }

  bool isFree()
  {
    return eventPrice==0;
  }
  bool isApproved()
  {
    return approved==1;
  }

  bool isSeatAvailable()
  {
    if(curr_participants==max_participants)
     {
       return false;
     }
    else
     {
       return true;
     }
  }
  factory CloudEvent.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();



    return CloudEvent(
      eventId: snapshot.id,
      eventName: snapshot.data()![eventNameField] as String,
      eventCategory: snapshot.data()![eventCategoryField] as String,
      eventDescription: snapshot.data()![eventDescriptionField] as String,
      eventPrice: snapshot.data()![eventPriceField] as int,
      eventPosterURL: snapshot.data()![eventPosterURLField] as String,
      eventLocation: snapshot.data()![eventLocationField] as String,
      eventCity: snapshot.data()![eventCityField] as String,
      eventCountry: snapshot.data()![eventCountryField] as String,
      organizerId: snapshot.data()![organizerIdField] as String,
      organizerUserName: snapshot.data()![organizerUserNameField] as String,
      start_dt:snapshot.data()![startDtField].toDate() as DateTime,
      end_dt: snapshot.data()![endDtField].toDate() as DateTime,
      max_participants: snapshot.data()![maxParticipantsField] as int,
      curr_participants: snapshot.data()![currParticipantsField] as int,
      approved: snapshot.data()![approvedField] as int,
      settlementAcc: snapshot.data()![settlementAccField] as String,
    );
  }
}


/*
  CloudEvent.fromSnapshot(QueryDocumentSnapshot<Map<String,dynamic>> snapshot):
        eventId=snapshot.id,
        eventName=snapshot.data()[eventNameField] as String,
        eventCategory=snapshot.data()[eventCategoryField] as String,
        eventDescription=snapshot.data()[eventDescriptionField] as String,
        eventPrice=snapshot.data()[eventPriceField] as int,
        eventPosterURL=snapshot.data()[eventPosterURLField] as String,
        eventLocation=snapshot.data()[eventLocationField] as String,
        eventCity=snapshot.data()[eventCityField] as String,
        eventCountry=snapshot.data()[eventCountryField] as String,
        organizerId=snapshot.data()[organizerIdField] as String,
        organizerUserName=snapshot.data()[organizerUserNameField] as String,
        start_dt=snapshot.data()[startDtField] as DateTime,
        end_dt=snapshot.data()[endDtField] as DateTime,
        max_participants=snapshot.data()[maxParticipantsField] as int,
        curr_participants=snapshot.data()[currParticipantsField] as int;
}*/
