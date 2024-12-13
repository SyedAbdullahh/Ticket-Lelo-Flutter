import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ticketlelo/constants/cloudStorageConstants.dart';

class CloudTicket
{
  final String ticketID;
  final String eventID;
  final String userID;
  final String userName;
  final int ticketNumber;
  final String eventName;
  final String eventPosterURL;
  final DateTime ticketStartDT;
  final DateTime ticketEndDT;
  final String eventVenue;
  final String eventCity;
  final int price;

  CloudTicket({required this.ticketID, required this.eventID, required this.userID, required this.userName, required this.ticketNumber, required this.eventName, required this.eventPosterURL, required this.ticketStartDT, required this.ticketEndDT, required this.eventVenue, required this.eventCity, required this.price});
  factory CloudTicket.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
  {
    final data = snapshot.data();

   /* String startDate = snapshot.data()![ticketStartDTField] as String;
    String endDate = snapshot.data()![ticketEndDTField] as String;
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime parsedStartDateTime = formatter.parse(startDate);
    DateTime parsedEndDateTime = formatter.parse(endDate);*/

    return CloudTicket(
      ticketID: snapshot.id,
      eventName: snapshot.data()![ticketEventNameField] as String,
      eventID: snapshot.data()![eventIDField] as String,
      userID: snapshot.data()![userIDField] as String,
      userName: snapshot.data()![ticketUserNameField] as String,
      ticketNumber: snapshot.data()![ticketNumberField] as int,
      eventPosterURL: snapshot.data()![ticketEventPhotoURLField] as String,
      ticketStartDT: snapshot.data()![ticketStartDTField].toDate() as DateTime,
      ticketEndDT: snapshot.data()![ticketEndDTField].toDate() as DateTime,
      eventVenue: snapshot.data()![ticketEventVenueField] as String,
      eventCity: snapshot.data()![ticketEventCityField] as String,
      price: snapshot.data()![ticketPriceField] as int,
    );
  }

  bool isFree()
  {
    return price==0;
  }
}